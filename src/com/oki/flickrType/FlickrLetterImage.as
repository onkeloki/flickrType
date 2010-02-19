package com.oki.flickrType {
	import mx.collections.ArrayCollection;
	import mx.controls.Image;
	import mx.events.FlexEvent;

	import flash.system.Security;

	import mx.controls.Alert;

	import com.adobe.webapis.flickr.PagedPhotoList;
	import com.adobe.webapis.flickr.Photo;
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;

	import mx.containers.Box;



	Security.allowDomain(["api.flickr.com", "flickr.com", "*"]);
	Security.allowInsecureDomain(["api.flickr.com", "flickr.com", "*"]);

	/**
	 * @author marko.luft
	 */

	
	
	
	
	
	public class FlickrLetterImage extends Box {

		
		private var service : FlickrService;
		private var maxResults : Number = 10;
		static var cachedPhotos : ArrayCollection;
		static var cachedChars : Array ;

		[Bindable] 
		private var _api_key : String;		

		[Bindable]
		private var _letter : String = "";

		
		private var img : Image;

		public function FlickrLetterImage() {
			if(cachedPhotos == null) {
				cachedPhotos = new ArrayCollection();
				cachedChars = new Array();
			}
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			addEventListener(FlexEvent.CREATION_COMPLETE, creationcomplete);
			width = 75;
			height = 75;
			setStyle("backgroundColor", 0xffffff);
		}

		private function creationcomplete(event : FlexEvent) : void {
			service = new FlickrService(_api_key);
			service.addEventListener(FlickrResultEvent.GROUPS_POOLS_GET_PHOTOS, onPhotosSearch);
			if(isCached(_letter)) {
				getFromCach(_letter);
			} else {
				var a : Array = getTagAndGroup(_letter);
				if(a[0] == " ")return;
				service.groups.pools.getPhotos(a[1], a[0], a[0], maxResults);
			}
		}

		
		
		
		private function getTagAndGroup(letter : String) : Array {
			var tag : String = "";
			var group_id : String = "";
			switch (letter) {
				case " ":
					tag = " ";
					group_id = '34231816@N00';           // Letter group
					break;
				case "a":
					tag = "aa";
					group_id = '27034531@N00';           // Letter group
					break;
				case "i":
					tag = "ii";
					group_id = '27034531@N00';           // Letter Group
					break;
				case "?":
					tag = "Question Mark";
					tag = "questionmark";              // Not sure which to use
					group_id = '34231816@N00';           // Puncuation group
					break;
				case "+":
					tag = "plus";
					group_id = '34231816@N00';           // Puncuation group
					break;
				case "&":
					tag = "ampersand";
					group_id = '34231816@N00';           // Puncuation group
					break;
				case "!":
					tag = "exclamation";
					group_id='34231816@N00';           // Puncuation group
					break;
	            case ".":
	                tag = "period";
	                group_id='34231816@N00';           // Puncuation group
	                break;
	            case "0":
	                tag = "00";
	                group_id='54718308@N00';           // Number Group
	                break;
	            case ("1"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
				case ("2"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
				case ("3"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
				case ("4"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
	            case ("5"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
	            case ("6"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
	            case ("7"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
	            case ("8"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
	            case ("9"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
	            case ("0"):
	                tag = letter;
	                group_id='54718308@N00';           // Number Group
	                break;
	            default:
	                tag = letter;
	                group_id='27034531@N00'; 			// Letter Group
	                break;
			}
			
			return new Array(tag, group_id);
		}

		private function getFromCach(letter:String):void{
			
			for(var i:Number = 0; i < cachedChars.length; i++){
				if(cachedChars[i] == letter) {
					img = new Image();
					var photo:Photo = cachedPhotos.getItemAt(i) as Photo;
					img.source = 'http://static.flickr.com/' + photo.server + '/' + photo.id + '_' + photo.secret + '_s.jpg';
					addChild(img);
				}
			}
		}


		private function isCached(letter:String):Boolean{
			for(var i:Number = 0; i < cachedChars.length; i++){
				if(cachedChars[i] == letter)return true;
			}
			return false;
		}

		private function addToCach(photo:Photo,letter:String):void {
			cachedPhotos.addItem(photo);
			cachedChars.push(letter);
		}

		private function onPhotosSearch( event:FlickrResultEvent ):void {
			var photoList:PagedPhotoList = event.data["photos"];
			photoList.perPage = maxResults;
			var id:Number = randompicId(0, photoList.photos.length-1);
			var photo:Photo =photoList.photos[id];
			img = new Image();
			addToCach(photo,letter);
			img.source = 'http://static.flickr.com/' + photo.server + '/' + photo.id + '_' + photo.secret + '_s.jpg'; 
			addChild(img);
		}
			
			
		private function randompicId(min:int,max:int):Number{
			return Math.round(min + (Math.random() * (max - min)));
		}
			
		
		
		public function get letter() : String {	return _letter;	}
		public function set letter(letter : String) : void {_letter = letter; }
		public function get api_key() : String {		return _api_key;	}
		public function set api_key(api_key : String) : void {		_api_key = api_key;	}
	}
}
