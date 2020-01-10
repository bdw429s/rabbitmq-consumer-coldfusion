<cfscript>

consumer = createObject("component", "consumer").init(application.channel);

application.channel.basicConsume(
	"test-a",
	false,
	createDynamicProxy(consumer, ["com.rabbitmq.client.Consumer"])
);

</cfscript>