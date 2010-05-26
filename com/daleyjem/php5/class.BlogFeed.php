<?php
	class BlogFeed
	{
		public function BlogFeed(){}
		
		public function getBlogPosts($feedURL)
		{
			$dom = new DOMDocument();
			$dom->load($feedURL);
			$xPath = new DOMXPath($dom);
			$xPath->registerNamespace("atom", "http://www.w3.org/2005/Atom");
			
			$entries = $xPath->query("//atom:feed/atom:entry");
			$entryList = array();
			foreach ($entries as $entry)
			{
				$feed["title"]		= $xPath->query("./atom:title", $entry)->item(0)->nodeValue;
				$feed["link"]		= $xPath->query("./atom:link[@rel='alternate']", $entry)->item(0)->getAttributeNode("href")->value;
				$feed["date"]		= $xPath->query("./atom:published", $entry)->item(0)->nodeValue;
				$feed["author"]		= $xPath->query("./atom:author/atom:name", $entry)->item(0)->nodeValue;
				$feed["summary"]	= $xPath->query("./atom:summary", $entry)->item(0)->nodeValue;
				
				$entryList[] = $feed;
			}
			
			return $entryList;
		}
	}
?>