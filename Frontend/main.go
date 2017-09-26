package main

import (
	"html/template"
	"net/http"
)

var tpl *template.Template

func init() {
	tpl = template.Must(template.ParseGlob("public/*.html"))
}

func main() {
	//http.HandleFunc("/", idx)
	http.Handle("favicon.ico", http.NotFoundHandler())
	http.Handle("/", http.FileServer(http.Dir("public/")))
	http.ListenAndServe(":8080", nil)
}

/*func idx(w http.ResponseWriter, r *http.Request) {
	err := tpl.ExecuteTemplate(w, "index.html", nil)
	if err != nil {
		log.Println(err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
	}

	fmt.Println(r.URL.Path)
	fmt.Println("we got here")
}
*/
