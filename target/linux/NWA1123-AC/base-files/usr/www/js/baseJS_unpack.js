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

function showFullPath(str) {
  fr = 2;
  parent.frames[fr].document.open();
  parent.frames[fr].document.writeln(' <html>');
  parent.frames[fr].document.writeln(' <head>');
  parent.frames[fr].document.writeln(' <meta http-equiv=\"Content-Type\" content=\"text\/html; charset=iso-8859-1\">');
  parent.frames[fr].document.writeln(' <title>ZyXEL NWA1120-N<\/title>');
  parent.frames[fr].document.writeln(' <link href=\"..\/css\/expert.css\" rel=\"stylesheet\" type=\"text/css\">');
  parent.frames[fr].document.writeln(' <\/head>');
  parent.frames[fr].document.writeln(' <body>');
  parent.frames[fr].document.writeln(' <div class=\"path\">');
  parent.frames[fr].document.writeln(' <span class=\"i_path\">' + str + '<\/span>');
  parent.frames[fr].document.writeln(' <\/div>');
  parent.frames[fr].document.writeln(' <\/body>');
  parent.frames[fr].document.writeln(' <\/html>');
  parent.frames[fr].document.close();
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

function checkLogout() {
  var flag;
  flag = confirm("Are you sure you want to log out?");
  if (flag) top.location.href = "../login/login_h.html";
}

function checkExit() {
  var flag;
  flag = confirm("Are you sure you want to Exit");
  if (flag) top.location.href = "../login/login_h.html";
}

function showtab() {
  var string = document.getElementById("advanced").style.display;
  if (string == "") {
    document.getElementById("advanced").style.display = "none";
    document.getElementById("showWord").innerHTML = "more...";
  } else if (string == "none") {
    document.getElementById("advanced").style.display = "";
    document.getElementById("showWord").innerHTML = "hide more";
  }
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
// end script here -->

