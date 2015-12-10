ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body
  indexes user.email, as: :author
end
