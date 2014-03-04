<%@ tag body-content="scriptless"%>
  
<!DOCTYPE html>

<html>
    <head>
        <title>Teste</title>
        <link rel="stylesheet" media="screen" href="stylesheets/jquery.dataTables_themeroller.css">
        <link rel="stylesheet" media="screen" href="stylesheets/swanky-purse/jquery-ui-1.10.3.custom.css">
        
        <link rel="shortcut icon" type="image/png" href="@routes.Assets.at("images/favicon.png")">
        
        <script src="javascripts/jquery-2.0.3.js" type="text/javascript"></script>
        <script src="javascripts/jquery.dataTables.min.js" type="text/javascript"></script>
        <script src="javascripts/jquery-ui-1.10.3.custom.js" type="text/javascript"></script>
		
		<style>
			body {background: rgb(255, 253, 192);}
			label, input { display:block; }
   			input.text { margin-bottom:12px; width:95%; padding: .4em; }
    		fieldset { padding:0; border:0; margin-top:25px; }
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
    <div style="background: #261803 url(stylesheets/swanky-purse/images/ui-bg_diamond_8_261803_10x8.png) 50% 50% repeat; position: fixed; top: 0pt; left: 0; width: 100%; height: 100pt;">
    	<div style="width: 150pt; height: 100%;">
    		<img src="images/livros.jpg" style="width: 100%; height: auto" />
    	</div>
    	<div style="padding-left: 5pt; padding-top: 5pt; position: fixed; top:0pt; left: 150pt; height: 100pt; width: 300pt; color: #f8eec9; font-size: 38pt; font-family: Georgia,Verdana,Arial,sans-serif;}">Sala de <br/>Leitura</div>
    	<div style="padding-left: 10pt; padding-top: 10pt; position: fixed; top:0pt; right: 10pt; height: 100pt; width: 300pt; color: #f8eec9; font-size: 12pt;">
    	<p align="right">Patrícia de Mello Tavares da Rocha | <b>Sair</b></p>
    	<p align="right">Colégio Estadual São Bernardo</p>
    	</div>
	</div>
	<div style="background: #261803 url(stylesheets/swanky-purse/images/ui-bg_diamond_8_261803_10x8.png) 50% 50% repeat; position: fixed; top: 100pt; left: 0; width: 150pt; height: 100%;">
		<div id="accordion" >
  			<h3>Consultas</h3>
  			<div>
  			 	<h4 align="right"><a id="link_emprestimos" href="#" style="text-decoration: none">Empréstimos</a></h4>
  			 	<h4 align="right"><a id="link_localizacoes" href="#" style="text-decoration: none">Localizações</a></h4>
  			 	<h4 align="right"><a id="link_livros" href="#" style="text-decoration: none">Livros</a></h4>
  			 	<h4 align="right"><a id="link_autores" href="./autor" style="text-decoration: none;">Autores</a></h4>
  			 	<h4 align="right"><a id="link_generos" href="./genero" style="text-decoration: none">Gêneros</a></h4>
  			 	<h4 align="right"><a id="link_alunos" href="./aluno" style="text-decoration: none">Alunos</a></h4>
  			 	<h4 align="right"><a id="link_turmas" href="./turma" style="text-decoration: none">Turmas</a></h4>
  			</div>
  			<h3>Gráficos</h3>
  			<div>
    			<h4 align="right"><a href="#" style="text-decoration: none">Melhores leitores</a></h4>
 			</div>
 			<h3>Administração</h3>
  			<div>
    			<h4 align="right"><a href="#" style="text-decoration: none">Usuários</a></h4>
    			<h4 align="right"><a href="#" style="text-decoration: none">Escolas</a></h4>
 			</div>
		</div>
	</div>
	<jsp:doBody/>
    </body>
</html>   