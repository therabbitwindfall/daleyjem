<?php
	class FormUtilities
	{
		public static function generateStateBox($fieldName, $defaultState = "")
		{
			$output = "";
			$stateArray = array("", "AB", "AL", "AK", "AZ", "AR", "BC", "CA", "CO", "CT", "DC", "DE",
								"FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MB",
								"ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NB", "NC", "ND",
								"NE", "NH", "NJ", "NL", "NM", "NS", "NT", "NU", "NV", "NY", "OH",
								"OK", "ON", "OR", "PA", "PE", "QC", "RI", "SC", "SD", "SK", "TN",
								"TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "YT");
			
			$output .= "<select name=\"$fieldName\">\n";
			$stateCount = count($stateArray);
			for ($stateIndex = 0; $stateIndex < $stateCount; $stateIndex++)
			{
				$state = $stateArray[$stateIndex];
				$selected = "";
				if ($state == $defaultState) $selected = " selected=\"selected\"";
				$output .= "<option$selected>$state</option>\n";
			}
			$output .= "</select>\n";
			return $output;
		}
	}
?>