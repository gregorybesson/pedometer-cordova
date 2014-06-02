var PedometerCordova = {

    init: function(str, callback)
    {
        cordova.exec(
            function(data)
            {
                callback(data);
            },
            function(err)
            {
                callback(err);
            },
            "PedometerCordova",
            "init",
            [] // option : "debug", 0.5
        );
    },
        
    start: function(str, callback)
    {
        cordova.exec(
            function(data)
            {
                callback(data);
            },
            function(err)
            {
                callback(err);
            },
            "PedometerCordova",
            "start",
            []
        );
    },
    
    stop: function(str, callback)
    {
        cordova.exec(
            function(data)
            {
                callback(data);
            },
            function(err)
            {
                callback(err);
            },
            "PedometerCordova",
            "stop",
            []
        );
    }
};

module.exports = PedometerCordova;
