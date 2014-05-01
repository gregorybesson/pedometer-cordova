pedometer-cordova
=================

Pedometer plugin compatible with M7 chip

##How to install :

````
cordova plugin add https://github.com/gregorybesson/pedometer-cordova.git
````

Make sure you have the plugins files and CoreMotion and CoreLocation framework added to your project


![Alt text](/docs/img1.png "the files")

##How to use :

Init with callback function

```
window.PedometerCordova.init(function(data)
{
    console.log(JSON.stringify(data));
});
```

Start recording

```
window.PedometerCordova.start();
```

Stop recording

```
window.PedometerCordova.stop();
```

