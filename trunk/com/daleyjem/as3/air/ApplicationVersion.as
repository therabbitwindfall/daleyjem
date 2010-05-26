package com.daleyjem.as3.air
{
	/**
	 * @author Jeremy Daley
	 */
	public class ApplicationVersion
	{
		public var major:uint = 0;
		public var minor:uint = 0;
		public var build:uint = 0;
		public var revision:uint = 0;
		
		public function ApplicationVersion(versionString:String):void
		{
			var split:Array = versionString.split(".");
			
			if (split.length > 0) major = uint(split[0]);
			if (split.length > 1) minor = uint(split[1]);
			if (split.length > 2) build = uint(split[2]);
			if (split.length > 3) revision = uint(split[3]);
		}
		
		public function isGreaterThan(otherVersion:ApplicationVersion):Boolean
		{
			if (major > otherVersion.major)
			{
				return true;
			}
			else if (major == otherVersion.major)
			{
				if (minor > otherVersion.minor)
				{
					return true;
				}
				else if (minor == otherVersion.minor)
				{
					if (build > otherVersion.build)
					{
						return true;
					}
					else if (build == otherVersion.build)
					{
						if (revision > otherVersion.revision) return true;
					}
				}
			}
			
			return false;
		}
		
		public function toString():String
		{
			return String(major + "." + minor + "." + build + "." + revision);
		}
	}
}