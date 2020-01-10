component {

	function process(
		required string message
	) {

		// Let's see if we can access Application scope here.
		// Nope, "Element DSN is undefined in APPLICATION."
		var a = application.dsn;

	}

}