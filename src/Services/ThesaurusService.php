<?php

namespace Thesaurus\Services;

use PDO;
use Thesaurus\Database\Connection;

class ThesaurusService
{
    private PDO $db;

    public function __construct(Connection $connection)
    {
        $this->db = $connection->connect();
    }

    /**
     * Search for synonyms and antonyms of a given word
     */
    public function searchWord(string $word): array
    {
        $word = trim(strtolower($word));
        
        if (empty($word)) {
            return ['error' => 'Word cannot be empty'];
        }

        // First, find the lemma for the given word
        $lemma = $this->findLemma($word);
        
        if (!$lemma) {
            return ['error' => 'Word not found in thesaurus'];
        }

        // Get synonyms and antonyms
        $synonyms = $this->getSynonyms($lemma['id']);
        $antonyms = $this->getAntonyms($lemma['id']);
        $related = $this->getRelatedWords($lemma['id']);

        return [
            'word' => $word,
            'lemma' => $lemma,
            'synonyms' => $synonyms,
            'antonyms' => $antonyms,
            'related' => $related
        ];
    }

    /**
     * Find lemma by word name
     */
    private function findLemma(string $word): ?array
    {
        $sql = "
            SELECT l.*, lb.name as label_name, lb.abbr as label_abbr
            FROM lemma l
            JOIN label lb ON l.label_id = lb.id
            WHERE LOWER(l.name) = :word
            LIMIT 1
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->execute(['word' => $word]);
        
        return $stmt->fetch() ?: null;
    }

    /**
     * Get synonyms for a lemma
     */
    private function getSynonyms(int $lemmaId): array
    {
        return $this->getWordsByRelationType($lemmaId, 'synonym');
    }

    /**
     * Get antonyms for a lemma
     */
    private function getAntonyms(int $lemmaId): array
    {
        return $this->getWordsByRelationType($lemmaId, 'antonym');
    }

    /**
     * Get related words for a lemma
     */
    private function getRelatedWords(int $lemmaId): array
    {
        return $this->getWordsByRelationType($lemmaId, 'related');
    }

    /**
     * Get words by relation type (synonym, antonym, related)
     */
    private function getWordsByRelationType(int $lemmaId, string $relationType): array
    {
        // First, find all word_relation entries for this lemma
        $sql = "
            SELECT DISTINCT wr.article_id, wr.par_num, wr.group_num
            FROM word_relation wr
            WHERE wr.lemma_id = :lemma_id
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->execute(['lemma_id' => $lemmaId]);
        $relations = $stmt->fetchAll();

        $results = [];

        foreach ($relations as $relation) {
            // Get all words in the same article/paragraph but different groups for the relation type
            $sql = "
                SELECT DISTINCT l.name, l.name_tagged, wc.name as word_class, wc.abbr as word_class_abbr,
                       t.name as relation_type, lb.name as label_name
                FROM word_relation wr
                JOIN lemma l ON wr.lemma_id = l.id
                JOIN word_class wc ON wr.wordclass_id = wc.id
                JOIN type t ON wr.type_id = t.id
                JOIN label lb ON l.label_id = lb.id
                WHERE wr.article_id = :article_id 
                AND wr.par_num = :par_num
                AND t.name = :relation_type
                AND wr.lemma_id != :lemma_id
                ORDER BY wr.word_order
            ";

            $stmt = $this->db->prepare($sql);
            $stmt->execute([
                'article_id' => $relation['article_id'],
                'par_num' => $relation['par_num'],
                'relation_type' => $relationType,
                'lemma_id' => $lemmaId
            ]);

            $words = $stmt->fetchAll();
            $results = array_merge($results, $words);
        }

        // Remove duplicates
        $unique = [];
        foreach ($results as $word) {
            $key = $word['name'] . '_' . $word['word_class'];
            if (!isset($unique[$key])) {
                $unique[$key] = $word;
            }
        }

        return array_values($unique);
    }

    /**
     * Get all available words (for autocomplete or browsing)
     */
    public function getAllWords(int $limit = 100, int $offset = 0): array
    {
        $sql = "
            SELECT l.name, l.name_tagged, lb.name as label_name, lb.abbr as label_abbr
            FROM lemma l
            JOIN label lb ON l.label_id = lb.id
            ORDER BY l.name
            LIMIT :limit OFFSET :offset
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll();
    }

    /**
     * Search words by pattern (for autocomplete)
     */
    public function searchWordsByPattern(string $pattern, int $limit = 10): array
    {
        $pattern = trim(strtolower($pattern));
        
        if (strlen($pattern) < 2) {
            return [];
        }

        $sql = "
            SELECT DISTINCT l.name, l.name_tagged, lb.name as label_name
            FROM lemma l
            JOIN label lb ON l.label_id = lb.id
            WHERE LOWER(l.name) LIKE :pattern
            ORDER BY l.name
            LIMIT :limit
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':pattern', $pattern . '%', PDO::PARAM_STR);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll();
    }

    /**
     * Get statistics about the thesaurus
     */
    public function getStatistics(): array
    {
        $stats = [];

        // Total words
        $sql = "SELECT COUNT(*) as total FROM lemma";
        $stmt = $this->db->query($sql);
        $stats['total_words'] = $stmt->fetch()['total'];

        // Total relations
        $sql = "SELECT COUNT(*) as total FROM word_relation";
        $stmt = $this->db->query($sql);
        $stats['total_relations'] = $stmt->fetch()['total'];

        // Relations by type
        $sql = "
            SELECT t.name, COUNT(*) as count
            FROM word_relation wr
            JOIN type t ON wr.type_id = t.id
            GROUP BY t.name
            ORDER BY count DESC
        ";
        $stmt = $this->db->query($sql);
        $stats['relations_by_type'] = $stmt->fetchAll();

        // Words by class
        $sql = "
            SELECT wc.name, COUNT(DISTINCT wr.lemma_id) as count
            FROM word_relation wr
            JOIN word_class wc ON wr.wordclass_id = wc.id
            GROUP BY wc.name
            ORDER BY count DESC
        ";
        $stmt = $this->db->query($sql);
        $stats['words_by_class'] = $stmt->fetchAll();

        return $stats;
    }
}
