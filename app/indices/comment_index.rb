ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body
  indexes user.email, as: :author, sortable: true
end
