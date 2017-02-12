const email = (event, context, callback) => {
	callback(null, { statusCode: 200, body: '<h1>Terp | email</h1>' });
};

module.exports = { email };