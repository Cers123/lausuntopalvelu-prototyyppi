@statement_request_form = {
  title: "Otsikko"
  cover_text: "Saateteksti"
  coauthors: [
    { email: "kanssa.pyytaja@foo.bar" },
    { email: "kanssa.pyytaja2@foo.bar" }
  ]
  targets: [
    { email: "pyynnon.kohde@foo.bar" },
    { email: "pyynnon.kohde2@foo.bar" }
  ]
  deadline: '29.12.2011'
  sent_at:  '11.12.2011'
  readers: [
      name: "Luki Ja"
      email: "luki.ja@foo.bar"
    ,
      name: "Luk Ija"
      email: "luk.ija@foo.bar"
  ]
  editors: [
      name: "Ed Itoija"
      email: "ed.itoija@foo.bar"
    ,
      name: "Edit Oija"
      email: "edit.oija@foo.bar"
  ],
  text: "<h1>Lausuntopyyntö</h1><p>Olemme valmistelleet tätä paljon.</p><h2>Ohjeet</h2><p>Muista tykätä kaikista mietteistäni</p>"
}

@single_comment = {
  name: "Paavo Kommenttaattori"
  comment: "Seems quite fine"
  agrees: true
}

@request_summary = {
  summary: "<h2>Yhteenveto</h2><p>Kommentit olivat aika huonoja. En tykkää.</p>"
}
