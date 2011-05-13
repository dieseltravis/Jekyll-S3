module Jekyll
  class SortedNavigationBuilder < Generator
  
    safe true
    priority :high

    def generate(site)
      site.config['primary_navigation'] = site.pages.select{|p| !p.to_liquid["primarynavorder"].nil?}.sort_by! { |p| p.to_liquid["primarynavorder"] }
      
      sorted_nav = Hash.new { |hash, key| hash[key] = [] }
      site.pages.select{|p| !p.to_liquid["navorder"].nil?}.sort_by! { |p| p.to_liquid["navorder"] }.each do |p|
        sorted_nav[p.to_liquid["subfolder"]] << p
      end
      site.config["sorted_navigation"] = sorted_nav
    end

  end
end