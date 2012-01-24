exports.STATEMENT_REQUESTS = [
  title: "Otsikko"
  cover_text: "Saateteksti"
  comment_count: 5
  sections: [
      id: 1
      title: "Ensimmäinen otsikko"
      text: "Ensimmäinen kappale"
      section_comment_count: 2
      section_comments: [
          name: "Kommen Toija"
          comment_text: "Ihan hanurista"
          date: new Date()
          agrees: no
        ,
          name: "Komm En Toija"
          comment_text: "Parasta ikinä"
          date: new Date()
          agrees: yes
      ]
    ,
      id: 2
      title: "Toinen otsikko"
      text: "Toinen kappale"
      section_comment_count: 1
      section_comments: [
        name: "Kommen Toija"
        comment_text: "No joo"
        date: new Date()
        agrees: yes
      ]
  ]
  coauthors: [
    { email: "kanssa.pyytaja@foo.bar" },
    { email: "kanssa.pyytaja2@foo.bar"}
  ]
  targets: [
      email:          "pyynnon.kohde@foo.bar"
      has_replied:    false
      no_of_comments: 0
    ,
      email:          "pyynnon.kohde2@foo.bar"
      has_replied:    false
      no_of_comments: 0
  ]
  raw_deadline: new Date()
  deadline:
    day: 1
    month: 'tammi'
    year: 2011
  author:
    name:  "Omis Taja"
    email: "omistaja@foo.bar"
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
  ]
  created_at: new Date()
  sent_at: new Date()
  comments: [
      name: "Kommen Toija"
      comment: "No tää nyt oli tällanen"
      date: new Date()
      agrees: no
    ,
      name: "Kaiken Komm En Toija"
      comment: "Hyvää työtä, tää on hyvä juttu!"
      date: new Date()
      agrees: no
  ]
  summary: ""
]
