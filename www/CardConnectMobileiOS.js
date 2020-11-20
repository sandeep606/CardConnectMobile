var exec = require('cordova/exec');



module.exports.initialisePayment = function (arg0, success, error) {
    exec(success, error, 'CardConnectMobileiOS', 'initialisePayment', [arg0]);
};

module.exports.payWithCardDetails = function (arg0, success, error) {
    exec(success, error, 'CardConnectMobileiOS', 'payWithCardDetails', [arg0]);
};