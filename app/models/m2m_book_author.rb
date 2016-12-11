# == Schema Information
#
# Table name: m2m_book_authors
#
#  id        :integer          not null, primary key
#  author_id :integer          not null
#  book_id   :integer          not null
#
# Indexes
#
#  index_m2m_book_authors_on_author_id  (author_id)
#  index_m2m_book_authors_on_book_id    (book_id)
#

class M2mBookAuthor < ActiveRecord::Base
  belongs_to :author
  belongs_to :book
end
