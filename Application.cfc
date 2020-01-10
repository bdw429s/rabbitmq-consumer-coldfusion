component {

	this.name = "TestAB";
	this.javaSettings = {
		loadPaths = [
			"amqp-client-5.8.0.jar"
		]
	};

	function onApplicationStart() {

		application.factory = createObject("java", "com.rabbitmq.client.ConnectionFactory").init();
		application.factory.setHost("localhost");
		application.factory.setPort(5672);
		application.factory.setUsername("guest");
		application.factory.setPassword("guest");

		application.connection = application.factory.newConnection();

		application.channel = application.connection.createChannel();

		application.dsn = "test";
		application.utils = new utils();

	}

	function onRequestStart() {
		if(structKeyExists(url, "reinit")) {
			try {
				application.channel.close();
			} catch(any e) {}
			application.connection.close();
			applicationStop();
			location("index.cfm");
		}
	}

}