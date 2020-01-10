component accessors="true" {

	function init(
		required channel,
		consumerTag = ""
	) {
		variables.channel = arguments.channel;
		variables.consumerTag = arguments.consumerTag;

		variables.app = application; // ref to Application scope

		return this;
	}

	public void function handleDelivery(
		consumerTag,
		envelope,
		properties,
		body
	) {
		var message = charsetEncode(arguments.body, "utf-8");

		// Here we have no access to Application or Request scope
		// as we are running in detached Java Runnable thread.
		// Also ColdFusion won't handle any exceptions, so use <cftry>
		// blocks to handle and log errors properly.
		// Meanwhilte Server scope is available and can be used to
		// share data between your application and consumer.

		// We can have access to Application scope by reference
		writeLog(
			file = "test",
			type = "information",
			text = "#variables.app.dsn#"
		);

		// But not inside any other component
		// I think in Lucee you can use something like
		// getPageContext().setApplicationContext(variables.app);
		// and it should solve the problem, but not in ACF
		try {
			variables.app.utils.process(message);
		} catch(any e) {
			writeLog(
				file = "test",
				type = "error",
				text = "#e.Message#"
			);
		}

		var props = createObject("java", "com.rabbitmq.client.AMQP$BasicProperties")
			.builder()
			.contentType("application/json")
			.build();

		// https://javadoc.io/doc/com.rabbitmq/amqp-client/latest/com/rabbitmq/client/Channel.html
		// basicPublish(String exchange, String routingKey, AMQP.BasicProperties props, byte[] body)

		// this will work
		variables.channel.basicPublish(
			"",
			"test-b",
			javaCast("null", true), // no message properties
			message.getBytes()
		);

		// this won't work
		// error: The basicPublish method was not found.
		// due to props class "AMQP$BasicProperties"
		// while library requires "AMQP.BasicProperties"
		try {
			variables.channel.basicPublish(
				"",
				"test-b",
				props, // with message properties
				message.getBytes()
			);
		} catch(any e) {
			writeLog(
				file = "test",
				type = "error",
				text = "#e.Message#"
			);
		}

		variables.channel.basicAck(
			arguments.envelope.getDeliveryTag(),
			false
		);

	}

	public void function handleConsumeOk(
		string consumerTag
	) {
		variables.consumerTag = arguments.consumerTag;
	}

	public void function handleCancelOk(
		string consumerTag
	) {
		variables.channel.close();
	}

	public void function handleCancel(
		string consumerTag
	) {}

	public void function handleRecoverOk() {}

	public void function handleShutdownSignal(
		string consumerTag,
		sig
	) {}

}
