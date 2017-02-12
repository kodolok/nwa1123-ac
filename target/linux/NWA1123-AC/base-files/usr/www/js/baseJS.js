function MM_findObj(n, d) {
  var p, i, x;
  if (!d) d = document;
  if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
    d = parent.frames[n.substring(p + 1)].document;
    n = n.substring(0, p);
  }
  if (!(x = d[n]) && d.all) x = d.all[n];
  for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
  for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layer[i].document);
  if (!x && d.getElementById) x = d.getElementById(n);
  return x;
}

function MM_goToURL() {
  var i, args = MM_goToURL.arguments;
  document.MM_returnValue = false;
  for (i = 0; i < (args.length - 1); i += 2) eval(args[i] + ".location='" + args[i + 1] + "'");
}

function MM_showHideLayers() {
  var i, p, v, obj, args = MM_showHideLayers.arguments;
  for (i = 0; i < (args.length - 2); i += 3) if ((obj = MM_findObj(args[i])) != null) {
    v = args[i + 2];
    if (obj.style) {
      obj = obj.style;
      v = (v == 'show') ? 'visible' : (v == 'hide') ? 'hidden' : v;
    }
    obj.visibility = v;
  }
}

function MM_openBrWindow(theURL, winName, features) {
  window.open(theURL, winName, features);
}

function MM_swapImgRestore() {
  var i, x, a = document.MM_sr;
  for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
}

function MM_swapImage() {
  var i, j = 0,
    x, a = MM_swapImage.arguments;
  document.MM_sr = new Array;
  for (i = 0; i < (a.length - 2); i += 3) if ((x = MM_findObj(a[i])) != null) {
    document.MM_sr[j++] = x;
    if (!x.oSrc) x.oSrc = x.src;
    x.src = a[i + 2];
  }
}

function NN_getCookie( name ) {

  var start = document.cookie.indexOf( name + "=" );
  var len = start + name.length + 1;
  if ( ( !start ) &&
      ( name != document.cookie.substring( 0, name.length ) ) )
  {
    return null;
  }
  if ( start == -1 ) return null;
  var end = document.cookie.indexOf( ";", len );
  if ( end == -1 ) end = document.cookie.length;
  return unescape( document.cookie.substring( len, end ) );
}

function NN_deleteCookie( name, path, domain ) {
  if ( NN_getCookie( name ) ) document.cookie = name + "=" +
    ( ( path ) ? ";path=" + path : "") +
      ( ( domain ) ? ";domain=" + domain : "" ) +
      ";expires=Thu, 01-Jan-1970 00:00:01 GMT";
}

function checkLogout() {
  var flag;
  flag = confirm("Are you sure you want to log out?");
  if (flag) {
    NN_deleteCookie('AUTH', '/', '');
    top.location.href = "../login/login.html";
  }
}

function forceLogout() {
  NN_deleteCookie('AUTH', '/', '');
}

function MM_popupMsg(msg) {
  alert(msg);
}

var win = null;

function OpenNewWindow(mypage, w, h, myname) {
  var winl = (screen.width - w) / 2;
  var wint = (screen.height - h) / 2;
  settings = 'height=' + h + ',width=' + w + ',top=' + wint + ',left=' + winl + ',scrollbars=no,toolbar=no'
  win = window.open(mypage, myname, settings)
  if (parseInt(navigator.appVersion) >= 4) {
    win.window.focus();
  }
}

/**
 * getByClass(classname, tagname, root):
 * Return an array of DOM elements that are members of the specified class,
 * have the specified tagname, and are descendants of the specified root.
 * 
 * If no classname is specified, elements are returned regardless of class.
 * If no tagname is specified, elements are returned regardless of tagname.
 * If no root is specified, the document object is used.  If the specified
 * root is a string, it is an element id, and the root
 * element is looked up using getElementsById()
 */
function NN_getByClass(classname, tagname, root) {
    if (!root) root = document;
    else if (typeof root == 'string') root = document.getElementById(root);
    
    if (!tagname) tagname = '*';

    var all = root.getElementsByTagName(tagname);

    if (!classname) return all;

    var elements = []; 
    for(var i = 0; i < all.length; i++) {
        var element = all[i];
        if (isMember(element, classname)) 
            elements.push(element);      
    }

    return elements;

    function isMember(element, classname) {
        var classes = element.className;
        if (!classes) return false;
        if (classes == classname) return true;

        var whitespace = /\s+/;
        if (!whitespace.test(classes)) return false;

        var c = classes.split(whitespace);
        for(var i = 0; i < c.length; i++) {
            if (c[i] == classname) return true;
        }

        return false;
    }
}
function setElementsDisabledByClass_(classname, bool) {
  var arr = NN_getByClass(classname, '', document.body);
  for (var i = 0, len = arr.length; i < len; i++) {
    arr[i].disabled = bool;
  }
  return;
}
function NN_enableByClass(classname) {
  setElementsDisabledByClass_(classname, false);
  return;
}
function NN_disableByClass(classname) {
  setElementsDisabledByClass_(classname, true);
  return;
}
function NN_hideByClass(classname) {
  var arr = NN_getByClass(classname, '', document.body);
  for (var i = 0, len = arr.length; i < len; i++) {
    if (arr[i].style.display !== 'none') {
      arr[i].style.display = 'none';
    }
  }
  return;
}
function NN_showByClass(classname, style) {
  if (style == "" || style == undefined) style = "block";
  if (style.match(/table/i) && navigator.appVersion.match(/MSIE 7.0/i)) style = "block";
  var arr = NN_getByClass(classname, '', document.body);
  for (var i = 0, len = arr.length; i < len; i++) {
    arr[i].style.display = style;
  }
  return;
}

function NN_addClass(el, classname) {
  var pattern = '\\b' + classname + '\\b';
  if ((new RegExp(pattern).test(el.className)) != true) {
    el.className += ' ' + classname; 
  }
  return el;
}

function NN_removeClass(el, classname) {
  var pattern = '\\b' + classname + '\\b';
  el.className = 
      el.className.replace(new RegExp(pattern, ''));
  return el;
}


function NN_getById(elid) {
  return document.getElementById(elid);
}

function NN_getByName(elname) {
  return document.getElementsByName(elname);
}

function NN_val(x, opt_val) {
  // text
  function getTextVal_(el) {
    return el.value;
  }
  function setTextVal_(el, val) {
    el.value = val
    return el;
  }
  // checkbox
  function getCheckboxStatus_(el) {
    return ((el.checked == true) ? true : false);
  }
  function setCheckboxStatus_(el, val) {
    if (typeof val == 'string') {
      ((el.value == val) ? el.checked = true : el.checked = false);
    } else if (typeof val == 'boolean') {
      el.checked = val;
    }
    return el;
  }
  // radio
  function getRadioGroupVal_(els) {
    for (var i = 0, len = els.length; i < len; i++) {
      if (els[i].checked == true)
        return els[i].value;
    }
    return '';
  }
  function setRadioGroupVal_(els, val) {
    if (val) {
      for (var i = 0, len = els.length; i < len; i++) {
        if (els[i].value == val) {
          els[i].checked = true;
          break;
        }
      }
    } else {
      for (var i = 0, len = els.length; i < len; i++) {
        els[i].checked = false;
      }
    }
    return els;
  }
  // select
  function getSelectVal_(el) {
    return el.options[el.selectedIndex].value; 
  }
  function setSelectVal_(el, val) {
    for (var i = 0, len = el.options.length; i < len; i++) {
      if (el.options[i].value == val) {
        el.selectedIndex = i;
        break;
      }
    }
    return el;
  }

  var act, type;

  if (x == null) return x;

  act = (opt_val === undefined) ? 'get' : 'set';
  if ((typeof x == 'object') || (typeof x == 'function')) {
    if (x && x.nodeName) {
      if (x.nodeName.toLowerCase() == 'select') {
        type = 'select';
      } else if (x.nodeName.toLowerCase() == 'input') {
        type = x.type; 
      }
    } else if (x[0] && x[0].nodeName) {
      if (x[0].nodeName.toLowerCase() == 'input') {
        type = x[0].type; 
      }
    }
    switch(type) {
      case 'text': 
      case 'password':
      case 'button':
      case 'hidden':
        return (act == 'set') ? setTextVal_(x, opt_val) : getTextVal_(x);
        break;
      case 'radio': 
        return (act == 'set') ? setRadioGroupVal_(x, opt_val) : getRadioGroupVal_(x);
        break;
      case 'checkbox': 
        return (act == 'set') ? setCheckboxStatus_(x, opt_val) : getCheckboxStatus_(x);
        break;
      case 'select': 
        return (act == 'set') ? setSelectVal_(x, opt_val) : getSelectVal_(x);
        break;
      default: 
        if (act === 'set') 
          return uiAppendText(x, opt_val);
        break;
    }
  }
 
  return x;
}


function isValidStr(str) {
  //var regEx = /^[a-zA-Z][\w-]*$/;
  var regEx = /^[\x21-\x7E]*$/;
  return regEx.test(str);
}
function isValidStrWSpace(str) {
  //var regEx = /^[a-zA-Z][\w-]*$/;
  var regEx = /^[\x21-\x7E]*$|^[\x21-\x7E][\x20-\x7E]*[\x21-\x7E]$/;
  return regEx.test(str);
}
function isContactStr(str) {
  var regEx = /^[a-zA-Z][\w-@.]*$/;
  return regEx.test(str);
}
function isPasswd(str) {
  var regEx = /^[a-zA-Z][\w-]*$/;
  return regEx.test(str);
}
function isDomain(str) {
  var regEx = /^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*(\.([a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z]))$/;
  return regEx.test(str);
}
function isInteger(str) {
  var regEx = /(^0$)|(^-?[1-9]+\d*$)/;
  return regEx.test(str);
}
function isIp(str, min) {
  if (!min)
	strv6 = "0:0:0:0:0:0:0:0";
  else
	var strv6 = NN_val(min);
  if ((strv6 != "0:0:0:0:0:0:0:0") && (str == "0.0.0.0"))
	return true;
  else{
	if (str == "0.0.0.0")
    return false;
	var regEx = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	return regEx.test(str);
  }
}
function isIpV6(str) {
  var regEx = /^(^(([0-9A-F]{1,4}(((:[0-9A-F]{1,4}){5}::[0-9A-F]{1,4})|((:[0-9A-F]{1,4}){4}::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,1})|((:[0-9A-F]{1,4}){3}::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,2})|((:[0-9A-F]{1,4}){2}::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,3})|(:[0-9A-F]{1,4}::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,4})|(::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,5})|(:[0-9A-F]{1,4}){7}))$|^(::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,6})$)|^::$)|^((([0-9A-F]{1,4}(((:[0-9A-F]{1,4}){3}::([0-9A-F]{1,4}){1})|((:[0-9A-F]{1,4}){2}::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,1})|((:[0-9A-F]{1,4}){1}::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,2})|(::[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,3})|((:[0-9A-F]{1,4}){0,5})))|([:]{2}[0-9A-F]{1,4}(:[0-9A-F]{1,4}){0,4})):|::)((25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{0,2})\.){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{0,2})$$/;
  return regEx.test(str.toUpperCase());
}
function isIpV6WithPrefix(str) {
  var tmpStr = str.split("/");
  if (tmpStr.length > 2) {    
    return false;
  }
  if (isIpV6(tmpStr[0])) {
    if (!isNaN(tmpStr[1]) && isInteger(tmpStr[1])) {
      if ((1 <= eval(tmpStr[1])) && (eval(tmpStr[1]) <= 128)) { 
        return true;
      }
    }
  }
  return false;
}
function isIpRange(str) {
  var regEx = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
  var newStr = str.split("-");
  return ((regEx.test(newStr[0])) && (regEx.test(newStr[1])));
}
function isMac(str) {
  var regEx = /^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$/;
  return regEx.test(str);
}
function maskValidate(str, flag) {
	  var maskFilter = ["0", "128", "192", "224", "240", "248", "252", "254", "255"];
	  var i;
	  
	  if (flag == 2){
	    for(i = 0; i < maskFilter.length; i++){
			if (maskFilter[i] == str && maskFilter[i] == 255)
				return 2;
			else if (maskFilter[i] == str)
				return 1;
	    }
	  }
	  else if (flag == 1){
		if (str == 0)
		  return 1;
	  }
	  
	  return 0;
	}
/* WEBGUI Timeout Mechanism */
function updateMaxAge(timeoutIntvl) {
  var value = NN_getCookie("AUTH");
  if (timeoutIntvl == undefined) { timeoutIntvl = 10; }
  document.cookie = "AUTH=" + value + "; max-age=" + timeoutIntvl*60 +"; path=/";
  setTimeout('top.location.href = "../login/login.html"', timeoutIntvl*60*1000);
}
if (document.readyState) {
  updateMaxAge();
}

/* END of WEBGUI Timeout Mechanism*/
/**
 *
 */
var V_STR = 1;
var V_CONTACT = 2;
var V_PASSWD = 3;
var V_INT = 4;
var V_IP = 5;
var V_IPRANGE = 6;
var V_MAC = 7;
var V_IPV6 = 8;
var V_IPV6WITHPREFIX = 9;
var V_STRWSPACE= 10;
var V_DOMAIN = 11;
var V_MASK = 12;
var V_DUPLICATE_PORT = 13;
function validate(el, type, min, max) {
  var str = NN_val(el);
  var retVal = false;

  if ((type == V_STR) || (type == V_CONTACT) || (type == V_PASSWD) || (type == V_DOMAIN)) {
    if ((min <= str.length) && (str.length <= max)) { 
      if ((min == 0) && (str.length == 0)) { 
        retVal = true; 
      } else {
        if ((type == V_STR) && isValidStr(str)) { retVal = true; }
        else if ((type == V_CONTACT) && isContactStr(str)) { retVal = true; } 
        else if ((type == V_PASSWD) && isPasswd(str)) { retVal = true; }
        else if ((type == V_DOMAIN) && isDomain(str)) { retVal = true; }
      }
    }
  } else if (type == V_STRWSPACE) {
    if ((min <= str.length) && (str.length <= max)) { 
      if ((min == 0) && (str.length == 0)) { 
        retVal = true; 
      } else {
        if (isValidStrWSpace(str)) { retVal = true; }
      }
    }
  } else if (type == V_INT) {
    if (!isNaN(str) && isInteger(str)) {
      if ((min <= eval(str)) && (eval(str) <= max)) { retVal = true; }
    }
  } else if (type == V_IP) {
    if (isIp(str, min)) { retVal = true; } 
  } else if (type == V_IPV6) {
    if (isIpV6(str)) { retVal = true; } 
  } else if (type == V_IPV6WITHPREFIX) {
    if (isIpV6WithPrefix(str)) { retVal = true; } 
  } else if (type == V_IPRANGE) {
    if (isIpRange(str)) { retVal = true; } 
  } else if (type == V_MAC) {
    if (isMac(str)) { retVal = true; }
  } else if (type == V_MASK) {
    var regEx = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    if(regEx.test(str)){
		var strMask = NN_val(el);
		var i, flag=2;
		if ( strMask != "0.0.0.0" && strMask != "255.255.255.255"){
			var maskArray = new Array();
			var maskArray = strMask.split(".");
			for (i = 0; i < 4; i++)
				flag = maskValidate(maskArray[i], flag);
			if (flag) retVal = true;
		}
	}
  } else if (type == V_DUPLICATE_PORT) {
	var i;
	for (i = 0; i < max.length; i++){ 
		if(str == max[i]) break;
		if(i == (max.length - 1)) retVal = true;		
	}
  }

  if (retVal == true) {
    NN_removeClass(el, 'invalidinput');
  } else {
    NN_addClass(el, 'invalidinput');
  }

  return retVal;
}

function NN_stopLoading() {
  if (navigator.appName == "Microsoft Internet Explorer") {
    window.document.execCommand("Stop");
  } else {
    window.stop();
  }
}
// end script here -->


