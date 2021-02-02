({
    
    doInit : function(component, event, helper) {
        
        jQuery("document").ready(function(){
            console.log('loaded');
            
            $('#square1').draggable({ containment: "#container-1", scroll: false });
            $( "#square2" ).resizable();	
            $( "#selectable" ).selectable();
            $( "#sortable" ).sortable();
            $( "#sortable" ).disableSelection();
            $( "#square2" ).droppable({
                drop: function( event, ui ) {
                    $( this )
                    .addClass( "ui-state-highlight" )
                    .find( "p" )
                    .html( "Dropped!" );
                }
            });
        });              
    },
    
    clickButton : function(component, event, helper) {
        
        $('#paragraph').html("Random");
        
        
        
        
    }
})