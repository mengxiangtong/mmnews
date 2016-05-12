# news
新闻


避免Block的循环引用

什么是循环引用，什么时候发生循环引用
1 循环引用就是当self 拥有一个block的时候，在block 又调用self的方法。形成你中有我，我中有你，谁都无法将谁释放的困局。

 self.myBlock = ^{
    [self doSomething];
  };
       +-----------+           +-----------+
       |    self   |           |   Block   |
  ---> |           | --------> |           |
       | retain 2  | <-------- | retain 1  |
       |           |           |           |
       +-----------+           +-----------+
又或者

ClassA* objA = [[[ClassA alloc] init] autorelease];
  objA.myBlock = ^{
    [self doSomething];
  };
  self.objA = objA;

  +-----------+           +-----------+           +-----------+
  |   self    |           |   objA    |           |   Block   |
  |           | --------> |           | --------> |           |
  | retain 1  |           | retain 1  |           | retain 1  |
  |           |           |           |           |           |
  +-----------+           +-----------+           +-----------+
       ^                                                |
       |                                                |
       +------------------------------------------------+
这是时官方的解释。
大体意思就是，例如self 有一个button ，而你又要 调用 button的某个东西设置.

［self.button  ^｛ }］
到这步为止那就一点问题都没有，但是由于某些原因，你又要在这个block里调用
self.label.text = @"I am Label";
就变成这样了。

［self.button  ^｛
      self.label.text = @"I am Label";
 }］;

//这个时候就变成这样了。
  +-----------+           +-----------+           +-----------+
  |   self    |           |  button   |           |   Block   |
  |           | --------> |           | --------> |           |
  | retain 1  |           | retain 1  |           | retain 1  |
  |           |           |           |           |           |
  +-----------+           +-----------+           +-----------+
       ^                                                |
       |                                                |
       +------------------------------------------------+
大体理解就是这样，如果有偏差，欢迎指出。

解决方法
简而言之就一句话的事情：

__weak typeof (self) weakSelf = self;
例如上面那个例子，只要如下即可。

 __weak typeof (self) weakSelf = self;
［self.button  ^｛
      weakSelf.label.text = @"I am Label";
 }］;

//这个时候就变成这样了。
  +-----------+           +-----------+           +-----------+
  |   self    |           |  button   |           |   Block   |
  |           | --------> |           | --------> |           |
  | retain 1  |           | retain 1  |           | retain 1  |
  |           |           |           |           |           |
  +-----------+           +-----------+           +-----------+
       ^                                                |
       |                                                |
       + - - - - - - - - - - - - - - - - - - - - - - - -+
                               weak
