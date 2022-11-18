//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Sensor;


//! This app demonstrates how to use the Number Picker.

class NumberPickerApp extends Application.AppBase {

    // TODO: dedupe
    (:background)
    class commListener extends Communications.ConnectionListener {
    function initialize() {
        Communications.ConnectionListener.initialize();
    }
    function onComplete() {
        System.println("Transmit Complete");
    }

    function onError() {
        System.println("Transmit Failed");
    }
    }


    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        startSensor();
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        var view = new $.NumberPickerView();
        var delegate = new $.BaseInputDelegate(view);
        return [view, delegate] as Array<Views or InputDelegates>;
    }

    // Make sure to have your commListener registered

    public function startSensor() {

		var options = {
			:period => 4,
			:accelerometer => {
				:enabled => true,
				:sampleRate => 10
			},
		};
        Sensor.registerSensorDataListener(method(:onData), options);
    }

    public function onData(sensorData) {
        sendAccelData(sensorData.accelerometerData.x, sensorData.accelerometerData.y, sensorData.accelerometerData.z);
    }

    public function sendAccelData(x,y,z) {
        Communications.transmit(x+","+y+","+z, {}, self.commListener);
    }
}