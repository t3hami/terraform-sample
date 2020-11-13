var AWS = require('aws-sdk');
var s3 = new AWS.S3();

exports.handler = (event, context, callback) => {
    var bucketName = process.env.bucketName;
    var filename = process.env.filename;
    var keyName = getKeyName(filename);
    var content = 'This is a sample text file';

    var params = { Bucket: bucketName, Key: keyName, Body: content };

    s3.putObject(params, function (err, data) {
        if (err)
            console.log(err)
        else
            console.log("Successfully saved object to " + bucketName + "/" + keyName);
    });
};

function getKeyName(filename) {
    return filename + new Date();
}