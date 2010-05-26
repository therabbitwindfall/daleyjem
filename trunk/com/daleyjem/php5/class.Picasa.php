<?php
	class Picasa
	{
		private $apiUri = "http://picasaweb.google.com/data/feed/api/user/";
		
		private $mediaNS = "http://search.yahoo.com/mrss/";
		private $gphotoNS = "http://schemas.google.com/photos/2007";
		private $atomNS = "http://www.w3.org/2005/Atom";
		
		public function Picasa(){}
		
		public function getAlbumPhotos($userName, $albumID, $maxResults = 20)
		{
			$apiPathPrepend	= $this->apiUri . "$userName/albumid/$albumID" ;
			$apiPathAppend	= "?kind=photo&max-results=$maxResults";
			
			$feedURL = $apiPathPrepend . $apiPathAppend;

			$dom = new DOMDocument();
			$dom->load($feedURL);
			
			$xPath = new DOMXPath($dom);
			$xPath->registerNamespace("atom", $this->atomNS);
			$xPath->registerNamespace("gphoto", $this->gphotoNS);
			$xPath->registerNamespace("media", $this->mediaNS);
			
			$photoEntries = array();
			$photoEntries["user"]	= $userName;
			$photoEntries["page"]	= "http://picasaweb.google.com/$userName";
			$photoEntries["photos"]	= array();
			
			$entries = $xPath->query("//atom:feed//atom:entry");

			foreach ($entries as $entry)
			{
				$photoEntry = array();
				$mediaNS = $this->mediaNS;
				$photoEntry["title"]		= $xPath->query(".//atom:summary", $entry)->item(0)->nodeValue;
				$photoEntry["date"]			= $xPath->query(".//atom:published", $entry)->item(0)->nodeValue;
				$photoEntry["thumbnail"]	= $xPath->query(".//media:thumbnail", $entry)->item(0)->getAttributeNode("url")->value;
				$photoEntry["page"]			= $xPath->query(".//atom:link[@rel='alternate']", $entry)->item(0)->getAttributeNode("href")->value;
				
				$photoEntries["photos"][] = $photoEntry;
			}
			
			return $photoEntries;
		}
		
		public function getUserAlbums($userName)
		{
			$apiPathPrepend	= $this->apiUri . $userName;
			$apiPathAppend	= "?kind=album&access=visible";
			
			$feedURL = $apiPathPrepend . $apiPathAppend;

			$dom = new DOMDocument();
			$dom->load($feedURL);
			
			$xPath = new DOMXPath($dom);
			$xPath->registerNamespace("atom", $this->atomNS);
			$xPath->registerNamespace("gphoto", $this->gphotoNS);
			$xPath->registerNamespace("media", $this->mediaNS);
			
			$albumEntries = array();
			$albumEntries["user"]	= $userName;
			$albumEntries["page"]	= "http://picasaweb.google.com/$userName";
			$albumEntries["albums"]	= array();
			$albumEntries["avatar"]	= $xPath->query(".//gphoto:thumbnail")->item(0)->nodeValue;
			
			$entries = $xPath->query("//atom:feed//atom:entry");

			foreach ($entries as $entry)
			{
				$albumEntry = array();
				$mediaNS = $this->mediaNS;
				$albumEntry["id"]			= $xPath->query(".//gphoto:id", $entry)->item(0)->nodeValue;
				$albumEntry["title"]		= $xPath->query(".//atom:title", $entry)->item(0)->nodeValue;
				$albumEntry["date"]			= $xPath->query(".//atom:updated", $entry)->item(0)->nodeValue;
				$albumEntry["thumbnail"]	= $xPath->query(".//media:thumbnail", $entry)->item(0)->getAttributeNode("url")->value;
				$albumEntry["page"]			= $xPath->query(".//atom:link[@rel='alternate']", $entry)->item(0)->getAttributeNode("href")->value;
				
				$albumEntries["albums"][] = $albumEntry;
			}
			
			return $albumEntries;
		}
		
		public function getUserPhotos($userName, $maxResults = 20)
		{
			$apiPathPrepend	= $this->apiUri . $userName;
			$apiPathAppend	= "?kind=photo&access=visible&max-results=$maxResults";
			
			$feedURL = $apiPathPrepend . $apiPathAppend;

			$dom = new DOMDocument();
			$dom->load($feedURL);
			
			$xPath = new DOMXPath($dom);
			$xPath->registerNamespace("atom", $this->atomNS);
			$xPath->registerNamespace("gphoto", $this->gphotoNS);
			$xPath->registerNamespace("media", $this->mediaNS);
			
			$photoEntries = array();
			$photoEntries["user"]	= $userName;
			$photoEntries["page"]	= "http://picasaweb.google.com/$userName";
			$photoEntries["photos"]	= array();
			$photoEntries["avatar"]	= $xPath->query(".//gphoto:thumbnail")->item(0)->nodeValue;
			
			$entries = $xPath->query("//atom:feed//atom:entry");

			foreach ($entries as $entry)
			{
				$photoEntry = array();
				$mediaNS = $this->mediaNS;
				$photoEntry["title"]		= $xPath->query(".//atom:summary", $entry)->item(0)->nodeValue;
				$photoEntry["date"]			= $xPath->query(".//atom:published", $entry)->item(0)->nodeValue;
				$photoEntry["thumbnail"]	= $xPath->query(".//media:thumbnail", $entry)->item(0)->getAttributeNode("url")->value;
				$photoEntry["page"]			= $xPath->query(".//atom:link[@rel='alternate']", $entry)->item(0)->getAttributeNode("href")->value;
				
				$photoEntries["photos"][] = $photoEntry;
			}
			
			return $photoEntries;
		}
	}
?>