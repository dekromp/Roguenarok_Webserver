// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function isEven(n){
    if (n % 2 > 0){
        document.getElementById(n).style.backgroundColor= "#e1dded";
    }
    else{
        document.getElementById(n).style.backgroundColor= "#ffe0c2";
    }
}

function hidePruneThresholds(id1,id2){
    if (document.getElementById("tree_manipulation").value == "Exclude Selected Taxa"){
        document.getElementById(id1).style.display = "none";
        document.getElementById(id2).style.display = "none";
          }
    else if(document.getElementById("tree_manipulation").value == "Prune Selected Taxa"){
        document.getElementById(id1).style.display = "";
        document.getElementById(id2).style.display = "";
    }

} 

function hideAnalysisOptions(id1,id2,id3,id4){
    if (document.getElementById("taxa_analysis").value == "Rogue Taxa Analysis"){
        document.getElementById(id4).style.display = "none";
        document.getElementById(id1).style.display = "";
        document.getElementById(id2).style.display = "";
        document.getElementById(id3).style.display = "";
    }
    else if (document.getElementById("taxa_analysis").value == "LSI"){
        document.getElementById(id1).style.display = "none";
        document.getElementById(id2).style.display = "none";
        document.getElementById(id3).style.display = "none";
        document.getElementById(id4).style.display = "";

    }
    else if (document.getElementById("taxa_analysis").value == "TII"){
        document.getElementById(id1).style.display = "none";
        document.getElementById(id2).style.display = "none";
        document.getElementById(id3).style.display = "none";
        document.getElementById(id4).style.display = "none";    
    }
}