import React, { useState, useEffect, useRef } from "react"
import axios from "axios"

const normalize = (str) =>
  str.toLowerCase().normalize("NFKC")

const EventTagInput = ({ initialTags = [] }) => {
  const [input, setInput] = useState("")
  const [tags, setTags] = useState(initialTags)
  const [suggestions, setSuggestions] = useState([])
  const [highlightIndex, setHighlightIndex] = useState(0)
  const inputRef = useRef(null)

  console.log("🟦 initialTags (props):", initialTags)
  console.log("🟩 tags (state):", tags)

  useEffect(() => {
    if (input.trim().length > 0) {
      axios.get(`/tags/search?q=${input.trim()}`).then((res) => {
        const normalizedInput = normalize(input)

        const filtered = res.data.filter((tag) =>
          normalize(tag.name).includes(normalizedInput)
        )

        setSuggestions(filtered)
        setHighlightIndex(0)
      })
    } else {
      setSuggestions([])
    }
  }, [input])

  const addTag = (tagName) => {
    if (!tagName || tags.some(t => t.name === tagName)) return
    setTags([...tags, { name: tagName }])
    setInput("")
    setSuggestions([])
    setHighlightIndex(0)
    setTimeout(() => inputRef.current?.focus(), 0)
  }

  const removeTag = (name) => {
    setTags(tags.filter((t) => t.name !== name))
  }

  const handleKeyDown = (e) => {
    if (e.key === "Enter" && !e.nativeEvent.isComposing) {
      e.preventDefault()
      const selected = suggestions[highlightIndex]
      if (selected) {
        addTag(selected.name)
      }
    } else if (e.key === "ArrowDown") {
      setHighlightIndex((i) => (i + 1 < suggestions.length ? i + 1 : 0))
    } else if (e.key === "ArrowUp") {
      setHighlightIndex((i) => (i - 1 >= 0 ? i - 1 : suggestions.length - 1))
    }
  }

  return (
    <div className="space-y-2">

      <input
        ref={inputRef}
        type="text"
        value={input}
        onChange={(e) => setInput(e.target.value)}
        onKeyDown={handleKeyDown}
        placeholder="既存タグから選択（例：もくもく会、懇親会）"
        className="w-full border p-2 rounded-lg text-sm"
      />

      {input && suggestions.length > 0 && (
        <ul className="mt-1 bg-white border rounded shadow max-h-48 overflow-auto z-10 relative">
          {suggestions.map((tag, index) => (
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

      {input && suggestions.length === 0 && (
        <div className="mt-1 text-sm text-gray-400 px-2">
          ※登録済みのタグから選んでください
        </div>
      )}

      <div className="flex flex-wrap gap-1 mt-2">
        {tags.map((tag) => (
          <div key={tag.name} className="bg-teal-600 text-white px-3 py-2 rounded-full text-sm flex items-center gap-2 shadow-sm">
            <i className="fas fa-tag text-xs"></i>
            <span>{tag.name}</span>
            <button
              type="button"
              onClick={() => removeTag(tag.name)}
              className="text-white hover:text-orange-300"
            >
              ×
            </button>
            <input type="hidden" name="event[tag_names][]" value={tag.name} />
          </div>
        ))}
      </div>
    </div>
  )
}

export default EventTagInput