import React, { useState, useEffect, useRef } from "react"

const normalize = (str) =>
  str.toLowerCase().normalize("NFKC")

const UserTagInput = ({ initialTags = [], tagCandidates = [] }) => {
  const [input, setInput] = useState("")
  const [tags, setTags] = useState(initialTags)
  const [highlightIndex, setHighlightIndex] = useState(0)
  const inputRef = useRef(null)

  const filteredSuggestions = tagCandidates
    .filter((tag) =>
      normalize(tag.name).includes(normalize(input)) &&
      !tags.some((t) => t.name === tag.name)
    )

  const addTag = (tagName) => {
    if (tagName && !tags.some(t => t.name === tagName)) {
      setTags([...tags, { name: tagName }])
    }
    setInput("")
    setHighlightIndex(0)
  }

  const removeTag = (name) => {
    setTags(tags.filter(t => t.name !== name))
  }

  const handleKeyDown = (e) => {
    if (e.key === "Enter" && !e.nativeEvent.isComposing) {
      e.preventDefault()
      const targetTag = filteredSuggestions[highlightIndex]
      addTag(targetTag ? targetTag.name : input)
    } else if (e.key === "ArrowDown") {
      setHighlightIndex((i) => (i + 1 < filteredSuggestions.length ? i + 1 : 0))
    } else if (e.key === "ArrowUp") {
      setHighlightIndex((i) => (i - 1 >= 0 ? i - 1 : filteredSuggestions.length - 1))
    }
  }

  return (
    <div className="space-y-2">
      <label className="block text-sm font-semibold text-gray-700">
        <i className="fas fa-tags mr-1 text-gray-500"></i>興味タグ
      </label>

      <input
        ref={inputRef}
        type="text"
        value={input}
        onChange={(e) => setInput(e.target.value)}
        onKeyDown={handleKeyDown}
        placeholder="例：野球好き、飲み会、カラオケなど"
        className="w-full border p-2 rounded-lg text-sm"
      />

      {input && filteredSuggestions.length > 0 && (
        <ul className="mt-1 bg-white border rounded shadow max-h-48 overflow-auto z-10 relative">
          {filteredSuggestions.map((tag, index) => (
            <li
              key={tag.name}
              onClick={() => addTag(tag.name)}
              onMouseEnter={() => setHighlightIndex(index)}
              className={`px-4 py-2 cursor-pointer text-sm flex justify-between ${
                highlightIndex === index ? "bg-blue-100" : ""
              }`}
            >
              <span>{tag.name}</span>
              <span className="text-gray-400 text-xs">{tag.user_count}人が登録済</span>
            </li>
          ))}
        </ul>
      )}

      {input && filteredSuggestions.length === 0 && (
        <div className="mt-1 text-sm text-red-500 px-2">
          このタグは登録されてないよ〜
        </div>
      )}

      <div className="flex flex-wrap gap-1 mt-2">
        {tags.map((tag) => (
          <div key={tag.name} className="bg-gray-500 text-white px-3 py-2 rounded-full text-sm flex items-center gap-2 shadow-sm">
            <i className="fas fa-tag mr-1 text-[10px]"></i>
            <span>{tag.name}</span>
            <button
              type="button"
              onClick={() => removeTag(tag.name)}
              className="text-white hover:text-red-500"
            >
              ×
            </button>
            <input type="hidden" name="user[tag_names][]" value={tag.name} />
          </div>
        ))}
      </div>
    </div>
  )
}

export default UserTagInput