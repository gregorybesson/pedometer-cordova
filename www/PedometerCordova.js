var PedometerCordova = {

    init: function(str, callback)
    {
        cordova.exec(
            function(data)
            {
                callback(JSON.parse(data));
            },
            function(err)
            {
                callback(err);
            },
            "PedometerCordova",
            "init",
            []
        );
    },
        
    record: function(str, callback)
    {
        cordova.exec(
            function(data)
            {
                callback(JSON.parse(data));
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
    
    stopRecording: function(str, callback)
    {
        cordova.exec(
            function(data)
            {
                callback(JSON.parse(data));
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
