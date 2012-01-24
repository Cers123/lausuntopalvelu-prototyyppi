CKEDITOR.plugins.add('omtemplatebutton',
{
    init: function(editor)
    {
	    var pluginName = 'omtemplatebutton';

	    editor.addCommand( pluginName,
	    {
	        exec : function( editor )
	        {
	        	var STATEMENT_SUMMARY_TEMPLATE = "<h2>Lausuntokooste</h2><p>&nbsp;</p><h3>Johdanto</h3><p><i>....</i></p><h3>Yleistä lausuntopalautteesta</h3><p><i>....</i></p><h3>Yksityiskohtainen lausuntopalaute</h3><p><i>....</i></p><p>&nbsp;</p>";
				var currtext = editor.getData()
				editor.setData(currtext + STATEMENT_SUMMARY_TEMPLATE)
	        },

	        canUndo : true
	    });

	    editor.ui.addButton('omtemplatebutton',
	    {
	        label: 'Tuo lausuntopohja',
	        command: pluginName,
	        className : 'cke_button_omtemplatebutton'
	    });
    }
});
