# space separated rvm ruby strings, first one is default, be explicity
# for path checking to work and avoid reinstalls (ie. ruby-1.8.7 vs shorthand 1.8.7)
set_unless[:rvm][:rubies] = "ruby-1.8.7"
