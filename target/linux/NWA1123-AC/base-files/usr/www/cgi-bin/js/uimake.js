function uiAppendHorizPortList(a,d){var b=a.id,c;for(i=1;i<=d;i+=2)c=a.rows[0].insertCell(-1),c.innerHTML=""+i,c=a.rows[1].insertCell(-1),c.id=b+"@"+i;for(i=2;i<=d;i+=2)c=a.rows[2].insertCell(-1),c.innerHTML=""+i,c=a.rows[3].insertCell(-1),c.id=b+"@"+i;d%2!=0&&(a.rows[2].insertCell(-1),a.rows[3].insertCell(-1))}
function uiMakeElSel(a){for(var d=document.createElement("select"),b=0,c=a.length;b<c;b++){var e=document.createElement("option");e.text=a[b][0];e.value=a[b][1];try{d.add(e,null)}catch(f){d.add(e,d.options[null])}}return d}
function uiMake(a){function d(a){return Object.prototype.toString.call(a)==="[object Array]"}if(!d(a))return uiMake.call(this,Array.prototype.slice.call(arguments));var b=a[1],c=document.createElement(a[0]),e=1;if(typeof b==="object"&&b!==null&&!d(b)){for(var f in b)c[f]=b[f];e=2}b=e;for(e=a.length;b<e;b++)d(a[b])?c.appendChild(uiMake(a[b])):c.appendChild(document.createTextNode(a[b]));return c};


function uiAppendText(x, val) {
  if (x) {
    if (val && typeof val == 'string') {
      var newtext = document.createTextNode(val);
      try {
        if (x.childNodes.length > 0) {
          x.insertBefore(newtext, x.childNodes[0]);
        } else {
          x.appendChild(newtext);
        }
      }
      catch (ex) {trace(ex);}
    } else {
      for (var i in x) {
        if (NN_getById(i)) uiAppendText(NN_getById(i), x[i]);
      }
    }
  }

  return x;
}

function uiFillOutForm(data) {
  for (var i in data) {
    x = (NN_getById(i));  
    if (x) NN_val(x, data[i]);
  }
  return data;
}
