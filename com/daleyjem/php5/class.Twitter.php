<?php
	class Twitter
	{
		public function Twitter(){}
		
		public function getUserTweets($userName, $format="json", $limit="1")
		{
			$url = "http://api.twitter.com/1/statuses/user_timeline.$format?screen_name=$userName&count=$limit";
			$ch = curl_init($url);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			$data = curl_exec($ch);
			curl_close($ch);
			return $data;
		}
	}
?>