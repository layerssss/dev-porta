dev-porta
=========

找一个空闲的端口然后启动你的应用（并且把地址加到一个首页上公之于众）

##安装

通过npm进行安装: `sudo npm install dev-porta -g`

##使用方法

1. 启动首页

    sudo dev-porta 

需要`sudo`是因为首页默认运行在80端口，当然你也可以改变，例如：`PORT=3000 dev-porta`

2. 设置第一个项目

请在第一个项目的目录下加入`.dev-porta.json`格式类似于：

    {
      "ports":{
        "web": "PORT" //如果你的应用程序用环境变量`PORT`控制端口的话..
      },
      "command": "node", //这里调用的是 child_process.spawn
      "args": "app.js" 
    }

3. 启动刚刚设置好的项目

在项目的目录下执行：`dev-porta`

4. 重复2~3设置并启动好其他项目

5. 打开浏览器去 `http://localhost/` 看看是不是列出了所有项目的链接，可以把这个页面告诉测试mm去了~\(≧▽≦)/~啦啦啦
