const hidingFileName = '.hideInTxtEd';

const fs = require('fs');
const path = require('path')
const getDirectories = rootDir => fs.readdirSync(rootDir).map(file => path.join(rootDir,file)).filter(filePath => fs.lstatSync(filePath).isDirectory());
const fileExists = path => fs.existsSync(path) && fs.lstatSync(path).isFile();
const dirExists = path => fs.existsSync(path) && fs.lstatSync(path).isDirectory();

let pathsToHide=[], addedListenerOnPath=[], allProjPaths=[];

function lookForStuffToHide(curPath) {
 getDirectories(curPath).forEach(lookForStuffToHide);
 const hideListFilePath = path.join(curPath, hidingFileName);
 if (fileExists(hideListFilePath)) {
  const subFilesToHide = fs.readFileSync(hideListFilePath).toString().split('\n').filter(s => s.length && s[0]!=='#');
  subFilesToHide.forEach(file => {
   const fullPath = path.join(curPath, file);
   pathsToHide.push(fullPath);
  });
 }
}

function addClasses(treeView) {
 const $spans = treeView.find('span.icon-file-directory, span.icon-file-text');
 for (let i=0;i<$spans.length;++i) {
  let $span = $spans.eq(i);
  $span.parents('li').eq(0).toggleClass('hide-files-hide', pathsToHide.indexOf($span.data('path'))>-1);
 }
}

function addListenerToDirEntry(treeView, entryDir) {
 if (entryDir.entries!==undefined) Object.keys(entryDir.entries).forEach(subEntry => {
  addListenerToDirEntry(treeView, entryDir.entries[subEntry])
 });
 if (addedListenerOnPath.indexOf(entryDir.path)===-1 && entryDir.onDidExpand!==undefined) {
  addedListenerOnPath.push(entryDir.path);
  entryDir.onDidExpand(()=>{
   addClasses(treeView);
   addListenerToDirEntry(treeView, entryDir);
  });
 }
}

function scanPaths(paths) {
 pathsToHide=[];
 addedListenerOnPath=[];
 paths.forEach(lookForStuffToHide);
 pathsToHide = pathsToHide.filter(itemPath => fs.existsSync(itemPath));
 let expandableDirs = pathsToHide.map(curPath => fs.lstatSync(curPath).isFile() ? path.dirname(curPath) : curPath);
 expandableDirs = expandableDirs.filter((dir,pos) => expandableDirs.indexOf(dir)===pos);
 atom.packages.activatePackage('tree-view').then(result => {
  treeView = result.mainModule.treeView
  expandableDirs.forEach(dir => addListenerToDirEntry(treeView, treeView.entryForPath(dir).directory));
  addClasses(treeView);
 });
}

atom.project.onDidChangePaths(newPaths => {
 allProjPaths = newPaths;
 scanPaths(allProjPaths);
});

atom.project.onDidAddBuffer(buf => {
 if (buf.file!==undefined && buf.file.path!==undefined && path.basename(buf.file.path)===hidingFileName && buf.onDidSave!==undefined) {
  buf.onDidSave(() => treeView!==null && scanPaths(allProjPaths));
 }
});
