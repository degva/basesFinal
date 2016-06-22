var pgConn = {

	getConnObj : function() {
		return {
			host: 'localhost',
			port: 5432,
			database: 'postgres',
			user: 'postgres'
		}
	}
}
module.exports = pgConn;
