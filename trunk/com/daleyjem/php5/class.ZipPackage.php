<?php
	class ZipPackage extends ZipArchive
	{
		public function __construct($tempFilename)
		{
			$this->open($tempFilename, ZIPARCHIVE::OVERWRITE);
		}
		
		public function __destruct()
		{
			$this->close();
		}
		
		public function addDirectory($tempDirectory, $addOnlyContents = false)
		{
			$dirPrefix = "";
			if (!$addOnlyContents)
			{
				$split = explode("/", $tempDirectory);
				$dirPrefix = $split[count($split) - 1];
			}
			echo $dirPrefix;
			$this->addDirectoryContents($tempDirectory, $dirPrefix);
		}
		
		private function addDirectoryContents($tempDirectory, $dirPrefix)
		{
			$dir = opendir($tempDirectory);
			
			while (false !== ($file = readdir($dir)))
			{
				if ($file == "." || $file == "..") continue;
				
				$addFile = ($dirPrefix == "") ? ($file) : ($dirPrefix . "/" . $file);
				if (filetype($tempDirectory . "/" . $file) == "dir")
				{
					$this->addDirectoryContents($tempDirectory . "/" . $file, $addFile);
				}
				else
				{
					$this->addFile($tempDirectory . "/" . $file, $addFile);
				}
			}
			
			closedir($dir);
		}
	}
?>