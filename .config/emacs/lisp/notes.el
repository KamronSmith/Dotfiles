(defvar kam-notes-nonfiction-book-template
  "* Questions to ask the book
** What is the book about?
** What is the book actually saying?
** Is it true?
** Why do you care?
* Structure Of Understanding
** Definitions
** Index
** Key Ideas
* Quotes"
  "Template to insert when creating a literature note for fiction media.")

(defvar kam-notes-fiction-template
  "* Questions to ask the book
** What is the unity of the plot in the story?
** What are the roles that the various characters play, and what key events are they in?
** Is it a likely story? Why?
** Does the work satisfy your heart and mind? Why?
** Do you appreciate the beauty of the work? Why?
* Structure of understanding
** Characters
** Key Events
** Themes
* Quotes"
  "Template to insert when creating a literature note for fiction media.")

(defun kam-notes-insert-nonfiction-book-template ()
  "Insert `kam-notes-nonfiction-book-template'."
  (end-of-buffer)
  (newline)
  (insert kam-notes-nonfiction-book-template))

(defun kam-notes-insert-literature-note-templete (template)
  "Insert TEMPLATE for creating a literature note, enhanced with `completing-read'."
  (interactive))
