# WTest-quintao

APP FLOW:
Primeiro ecrã tem duas opções:
-> POSTAL CODES (1-2), contem a funcionalidade 1 e 2.

-> ARTICLES, contem a funcionalidade 3 (está funcionalidade apenas a receber a data do webservice, podendo alterar entra os dois URLs através do botão no topo)
* não está a abrir o hero do artigo *

Dependências usadas:

Dependências instaladas através do CocoaPods.

pod "SwiftCSV"
pod 'Alamofire', '~> 5.2'


- SwiftCSV (https://github.com/swiftcsv/SwiftCSV)
Usada para fazer o parse do CSV descarregado. Depois do parse é usado o “namedRows” (ver PostalViewModal line - 93)
	// Uses SwiftCSV pod to convert string to CSV
        let csv:CSV = try CSV(string: myData)
        // Get dic with all rows
        let rows = csv.namedRows

- Alamofire
Usada para fazer pedidos e recolher dados WebService.
