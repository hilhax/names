class Name < ActiveRecord::Base
	self.table_name = "app.names"
    #paginates_per 10
	#default_scope { order('name asc') }

	belongs_to :name_gender, class_name: "Gender", foreign_key: "gender"

	filterrific(
	    default_settings: { :with_gender=>1, :with_letter=>'A', :with_meaning=>1},
	    filter_names: [
	      :sorted_by,
	      :with_gender,
	      :with_meaning,
	      :with_length,
		  :search_query,
		  :with_letter
	    ]
  	)
	
	scope :with_gender, lambda { |genders|
		where(:gender => [*genders])
	}

	scope :with_meaning, lambda { |meanings|
		where(:name_type => [*meanings])
	}

	scope :with_letter, lambda { |letter|
	    if(letter.length<=2)	
			where("name like '#{letter}%'")
		end			
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

	

	def self.get_random_record_of_the_day(gender)
		n = Name.where('gender=? and date_retr=now()::date',gender.to_s)
		if(n.count>0)
			n.first
		else
			n = Name.where('gender=? and name_type<>5 and (date_retr is null OR date_retr<now()::date-30)',gender.to_s).order('RANDOM()').first
			n.date_retr = DateTime.now
			n.save
			n
		end
	end

	def self.random_male
		self.get_random_record_of_the_day(1)
	end

	def self.random_female
		self.get_random_record_of_the_day(2)
	end

	def self.total_names
		Name.all.count
	end

	def self.total_male_names
		Name.where('gender=1').count
	end

	def self.total_female_names
		Name.where('gender=2').count
	end

	def self.total_muslim_names
		Name.where('name_type=5').count
	end

	def self.total_male_muslim_names
		Name.where('gender=1 and name_type=5').count
	end

	def self.total_female_muslim_names
		Name.where('gender=2 and name_type=5').count
	end
	
end
