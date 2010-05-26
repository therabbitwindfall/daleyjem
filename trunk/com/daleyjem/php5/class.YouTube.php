<?php
	class YouTube
	{
		private $dataURLPrepend = "http://gdata.youtube.com/feeds/api/users/";
		private $dataURLAppend = "/uploads";
		private $mediaNS = "http://search.yahoo.com/mrss/";
	
		public function YouTube(){}
		
		public function getUserVideos($userName)
		{
			$feedURL = $this->dataURLPrepend . $userName . $this->dataURLAppend;
            $dom = new DOMDocument();
			$dom->load($feedURL);
			
			$videoEntries = array();
			$videoEntries["user"] = $userName;
			$videoEntries["channel"] = "http://www.youtube.com/user/$userName";
			$videoEntries["videos"] = array();
			$xPath = new DOMXPath($dom);
			$xPath->registerNamespace('atom', "http://www.w3.org/2005/Atom");

			$entries = $dom->getElementsByTagName("entry");

			foreach ($entries as $entry)
			{
				$videoEntry = array();
				$mediaNS = $this->mediaNS;
				$videoEntry["title"]		= htmlentities($entry->getElementsByTagName("title")->item(0)->nodeValue, ENT_QUOTES);
				$videoEntry["description"]	= htmlentities($entry->getElementsByTagName("content")->item(0)->nodeValue, ENT_QUOTES);
				$videoEntry["date"]			= $entry->getElementsByTagName("published")->item(0)->nodeValue;
				$videoEntry["thumbnail"]	= $entry->getElementsByTagNameNS($mediaNS, "thumbnail")->item(0)->getAttributeNode("url")->value;
				$videoEntry["url"]			= $xPath->query(".//atom:link[@rel='alternate']", $entry)->item(0)->getAttributeNode("href")->value;
				$parseURL = parse_url($videoEntry["url"]);
				$parseString = parse_str($parseURL["query"], $queryArray);
				$videoEntry["id"]			= $queryArray["v"];
				$videoEntry["swf"]			= "http://www.youtube.com/v/" . $videoEntry["id"];
				
				$videoEntries["videos"][] = $videoEntry;
			}
				
			return $videoEntries;
		}
	}
?>