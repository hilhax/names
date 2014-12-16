class Name < ActiveRecord::Base
	self.table_name = "app.names"
    paginates_per 10

	belongs_to :name_gender, class_name: "Gender", foreign_key: "gender"
	
	scope :with_gender, lambda { |genders|
		where(:gender => [*genders])
	}
	

	scope :with_meaning, lambda { |meanings|
		where(:name_type => [*meanings])
	}

	scope :with_letter, lambda { |letter|	
		where("name like '#{letter}%'")
	}

	scope :with_length, lambda { |lengths|
		where(:name_length => [*lengths])
	}

	scope :sorted_by, lambda { |sort_option|
	
		order("names.name desc")
	}

	scope :search_query, lambda { |query|
	  return nil  if query.blank?
	  terms = query.downcase.split(/\s+/)
	  terms = terms.map { |e|
	    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
	  }	
	  num_or_conds = 1
	  where(
	    terms.map { |term|
	      "(LOWER(names.name) LIKE ? )"
	    }.join(' AND '),
	    *terms.map { |e| [e] * num_or_conds }.flatten
	  )
	}

	filterrific(
    default_settings: {},
    filter_names: [
      :sorted_by,
      :with_gender,
      :with_meaning,
      :with_length,
	  :search_query,
	  :with_letter
    ]
  )
end
