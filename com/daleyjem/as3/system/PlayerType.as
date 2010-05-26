package com.daleyjem.as3.system
{
	public final class PlayerType
	{
		/**
		 * Flash Player ActiveX control used by Microsoft Internet Explorer
		 */
		public static const ACTIVEX:String		= "ActiveX";
		/**
		 * Adobe AIR runtime (except for SWF content loaded by an HTML page, which has Capabilities.playerType set to "PlugIn")
		 */
		public static const DESKTOP:String		= "Desktop";
		/**
		 * External Flash Player or in test mode
		 */
		public static const EXTERNAL:String		= "External";
		/**
		 * Flash Player browser plug-in (and for SWF content loaded by an HTML page in an AIR application)
		 */
		public static const PLUGIN:String		= "PlugIn";
		/**
		 * Stand-alone Flash Player
		 */
		public static const STANDALONE:String	= "StandAlone";
	}
}