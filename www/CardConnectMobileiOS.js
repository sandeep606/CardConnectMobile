var exec = require('cordova/exec');



module.exports.initialisePayment = function (arg0, success, error) {
    exec(success, error, 'CardConnectMobileiOS', 'initialisePayment', [arg0]);
};
