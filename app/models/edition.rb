# == Schema Information
#
# Table name: editions
#
#  id                  :integer          not null, primary key
#  isbn                :string           not null
#  title               :string
#  annotation          :text
#  editor              :string
#  pages_count         :integer
#  language_code       :string
#  edition_category_id :integer
#  publisher_id        :integer
#  publication_year    :integer          default(1999)
#  cover               :string
#  created_at          :datetime
#  updated_at          :datetime
#  read                :boolean          default(FALSE)
#
# Indexes
#
#  index_editions_on_edition_category_id  (edition_category_id)
#  index_editions_on_publisher_id         (publisher_id)
#

class Edition < ApplicationRecord
  EMPTY_ISBN = 'unknown'.freeze

  belongs_to :category,
    class_name: EditionCategory,
    foreign_key: :edition_category_id
  belongs_to :publisher, optional: true
  has_many :book_in_editions
  has_many :books, through: :book_in_editions
  has_many :authors, through: :books

  scope :with_category_code, lambda { |code|
    joins(:category).where(edition_categories: { code: code })
  }
  scope :with_author, lambda { |author|
    if author.is_a? Author
      joins(:authors).where('authors.id = ?', author)
    else
      joins(:authors).where('authors.name = ?', author.to_s)
    end
  }

  scope :by_book_titles, lambda {
    includes(:books).order('books.title').group('editions.id')
  }
  scope :old_first, lambda { order(:publication_year) }
  scope :new_first, lambda { order(publication_year: :desc) }
  scope :by_updated_at, lambda { order(:updated_at) }
  scope :by_author, lambda {
    includes(:authors).
      order('authors.name').
      group('editions.id')
  }

  accepts_nested_attributes_for :books, allow_destroy: true

  validates_presence_of :isbn, :books

  mount_uploader :cover, ::BookCoverUploader

  def full_title
    title.presence || books.map(&:title).join('; ')
  end
end
