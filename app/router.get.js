'use strict';

var database = require(APPROOT + '/app/libs/database/database.js');

exports.home = function(req, res) {
	res.json({'message': 'Welcome to AniDex API'});
};

exports.torrents = function(req, res) {
	var options = {
		'limit':		0,
		'since':		new Date(),
		'ids':			[],
		'groups':		[],
		'categories':	[]
	};

	database.torrent.get(options, function(err, data) {
		if (err) { return res.json({ 'error': 'Database error.'}); };
		res.json(data);
	});
};

exports.whitelist = function(req, res) {
	database.torrent.whitelist(function(err, data) {
		if (err) { return res.json({ 'error': 'Database error.'}); };
		res.json(data);
	});
};

