	function JS_getBrowserObjects() {
		// Create an array to hold each of the browser's items.
		var tempArr = new Array();

		// Loop over each item in the browser's navigator object.
		for (var name in navigator) {
			var value = navigator[name];
			/*
			If the current value is a string or Boolean object, add it to the
			array, otherwise ignore the item.
			*/
			switch (typeof(value)) {
				case "string":
				case "boolean":
					/*
					Create a temporary string which will be added to the array.
					Make sure that we URL-encode the values using JavaScript's
					escape() function.
					*/
					var tempStr = "navigator." + name + "=" + escape(value);
					// Push the URL-encoded name/value pair onto the array.
					tempArr.push(tempStr);
					break;
			}
		}
		// Loop over each item in the browser's screen object.
		for (var name in screen) {
			var value = screen[name];
			/*
			If the current value is a number, add it to the array, otherwise
			ignore the item.
			*/
			switch (typeof(value)) {
				case "number":
					var tempStr = "screen." + name + "=" + escape(value);
					tempArr.push(tempStr);
					break;
			}
		}
		// Return the array as a URL-encoded string of name-value pairs.
		return tempArr.join("&");
	}