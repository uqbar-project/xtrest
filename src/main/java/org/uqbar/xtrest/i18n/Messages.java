package org.uqbar.xtrest.i18n;

import java.util.ResourceBundle;

public class Messages {
	private static final String BUNDLE_NAME = "messages"; //$NON-NLS-1$
	
	private static ResourceBundle resourceBundle;
	
	static {
		// initialize resource bundle
		resourceBundle = ResourceBundle.getBundle(BUNDLE_NAME);
	}
	
	private Messages() {
	}
	
	public static String SERVER_NO_CONTROLLER_DEFINED = "SERVER_NO_CONTROLLER_DEFINED";
	public static String SERVICE_NOT_FOUND_MAIN_TITLE = "SERVICE_NOT_FOUND_MAIN_TITLE";
	public static String SERVICE_NOT_FOUND_SUPPORTED_RESOURCES = "SERVICE_NOT_FOUND_SUPPORTED_RESOURCES";

	public static String getMessage(String key) {
		return resourceBundle.getString(key);
	}

}