<?php
	class Twitter
	{
		public function Twitter(){}
		
		public function getUserTweets($userName, $format="json")
		{
			$apiPrepend = "http://twitter.com/statuses/user_timeline/";
			$ch = curl_init("$apiPrepend$userName.$format");
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			$json = curl_exec($ch);
			curl_close($ch);
			return $json;
		}
	}
?>