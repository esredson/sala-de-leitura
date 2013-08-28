<%@ tag body-content="scriptless"%>
  
<!DOCTYPE html>

<html>
    <head>
        <title>Teste</title>
        <link rel="stylesheet" media="screen" href="stylesheets/jquery.dataTables_themeroller.css">
        <link rel="stylesheet" media="screen" href="stylesheets/swanky-purse/jquery-ui-1.10.2.custom.min.css">
        
        <link rel="shortcut icon" type="image/png" href="@routes.Assets.at("images/favicon.png")">
        
        <script src="javascripts/jquery-1.9.0.min.js" type="text/javascript"></script>
        <script src="javascripts/jquery.dataTables.min.js" type="text/javascript"></script>
        <script src="javascripts/jquery-ui-1.10.2.custom.min.js" type="text/javascript"></script>
		
		<style>
			body {background: rgb(255, 253, 192);}
			table.dataTable tr.even { background-color: #eacd86 !important; }
			table.dataTable tr.odd { background-color: #efec9f !important; }
			table.dataTable tr.even td.sorting_1 { background-color: #eacd86 !important; }
			table.dataTable tr.odd td.sorting_1 { background-color: #efec9f !important; }
			#tabela_wrapper {width: 50%;}
			.ui-widget {font-size: 14px;}
			.ui-accordion .ui-accordion-content {border: 0px !important; padding-top: 0.1em; padding-bottom: 0.1em; padding-right: 2em}
			.ui-accordion .ui-accordion-header {border: 0px; background: #675423 url(stylesheets/swanky-purse/images/ui-bg_diamond_25_675423_10x8.png) 50% 50% repeat;}
			.validateTips { border: 1px solid transparent; padding: 0.3em;}
		</style>
    </head>
    <body>
	<jsp:doBody/>
    </body>
</html>   