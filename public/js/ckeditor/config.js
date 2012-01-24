/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	config.language = 'fi';
	config.removePlugins = 'elementspath';
	config.extraPlugins = 'omtemplatebutton';
	config.toolbarCanCollapse = false;
	config.resize_maxWidth = 608;

	config.toolbar_RequestEditor =
	[
		{ name: 'format',  items: ['Format', 'Bold', 'Italic' ] },
		{ name: 'editing', items: ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo'] },
		{ name: 'links',   items: [ 'Link','Unlink'] },
		{ name: 'fscr',    items: ['Maximize'] }
	];

	config.toolbar_CoverTextEditor =
	[
		{ name: 'format',  items: ['Bold', 'Italic' ] },
		{ name: 'editing', items: ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo'] },
		{ name: 'links',   items: [ 'Link','Unlink'] },
		{ name: 'fscr',    items: ['Maximize'] }
	];


	config.toolbar_SummaryEditor =
	[
		{ name: 'format',  items: ['Format', 'Bold', 'Italic' ] },
		{ name: 'editing', items: ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo'] },
		{ name: 'links',   items: [ 'Link','Unlink'] },
		{ name: 'fscr',    items: ['Maximize'] },
		{ name: 'fscr',    items: ['omtemplatebutton'] }
	];

	config.toolbar = 'RequestEditor';
};
