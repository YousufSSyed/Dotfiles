
(function(){
  _ucUtils.registerHotkey(
  {
    id: "testKey",
    key: "g",
    modifiers: "Ctrl br Alt",
    
  },
  function(win,hotkey){
    const doc = win.document;
    const bmtb = CustomizableUI.AREA_BOOKMARKS;
    CustomizableUI.setToolbarVisibility(
      bmtb,
      doc.getElementById(bmtb).getAttribute("collapsed")==="true");
  });
})();